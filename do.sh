#!/bin/bash

set -e
set -o pipefail
export LANG=C

case "$BASH_SOURCE" in
*/*) prefix="${BASH_SOURCE%/*}";;
*)   prefix=.;;
esac

. $prefix/conf/do.cnf

die() {
	echo "ERROR: " "$@"
	exit 1
}

grep-alt-emails() {
	awk 'f{gsub("email:",""); gsub(",",""); print $0; exit}/X509v3 Subject Alternative Name/{f=1}'
}

email=${emails[0]}
[ -z "$email" ] && die "email missing"

cnf="$prefix/data/$email.cnf"
key="$prefix/data/$email.key"
csr="$prefix/data/$email.csr"

[ -d "$prefix/data" ] || mkdir "$prefix/data"

case "$1" in

create-key)	#-- Create key
	echo "* Creating key:"
	echo "  $key"
	echo
	openssl genrsa -passout "pass:$pass" -aes256 -out "$key" 4096
	echo
	;;

create-csr)	#-- Create csr
	echo "* Creating request:"
	echo "  $csr"
	echo

	export commonName email
	envsubst '$commonName,$email' <conf/smime.cnf >"$cnf"
	awk '{$0="email."(NR-1)"="$0}1' >>"$cnf" <<<"${emails[@]}"
	openssl req -config "$cnf" -new -key "$key" -passin "pass:$pass" -out "$csr" 

	echo
	echo "* Result:"
	openssl req -in "$csr" -noout -text | grep -E "(Subject|email:)"
	echo
	;;

test-api) #-- Test Sectigo API

	# All mail addresses
	csr_emails=( $(openssl req -in "$csr" -noout -text | grep-alt-emails) )

	# Last mail address is primary address!
	#csr_email=${csr_emails[-1]}
	# First mail address is primary address!
	csr_email=${csr_emails[0]}
	
	echo "* E-Mail:"
	echo "  $email"
	echo
	echo "* E-Mails:"
	echo "  ${emails[@]}"
	echo 
	echo "* E-Mail from request:"
	echo "  $csr_email"
	echo
	echo "* E-Mails from request:"
	echo "  ${csr_emails[@]}"
	echo 

	cert_types=$(curl "https://cert-manager.com/api/smime/v1/types?organizationId=$org_id" -s -X GET \
	    -H "Content-Type: application/json;charset=utf-8" \
	    -H "customerUri: $customer" \
	    -H "login: $admin_user" \
	    -H "password: $admin_pass")
	
	cert_type_id=$(jq ".[] | select (.name == \"$cert_type\") | .id" <<<"$cert_types")
	
	echo "* Cert-Type:"
	echo "  $cert_type_id = $cert_type"
	echo

	# Request input:
	# email is mandatory and overwrite subject alt names listed in csr.
	# As a result secondaryEmails are also mandary, to fill subject alt names.
	request="$(jo -- \
			-n orgId="$org_id" \
			-s firstName="$firstName" \
			-s middleName="" \
			-s lastName="$lastName" \
			-s commonName="$commonName" \
			-s csr="$(cat "$csr")" \
			-n certType="$cert_type_id" \
			-n term=365 \
			-s eppn="" \
			-s email="$csr_email" \
			-s secondaryEmails="$(jo -a -- "${csr_emails[@]}")" \
		)"
	
	echo "* Request:"
	jq . <<<"$request"
	echo

	response=$(curl 'https://cert-manager.com/api/smime/v1/enroll' -s -X POST \
	    -H "Content-Type: application/json;charset=utf-8" \
	    -H "customerUri: $customer" \
	    -H "login: $admin_user" \
	    -H "password: $admin_pass" \
		-d "$request")

	echo "Response:"
	jq . <<<"$response"
	orderNumber=$(jq .orderNumber <<<"$response")
	echo

	echo "* Returned orderNumber:"
	echo "  $orderNumber"
	echo

	p7b="$prefix/data/$email-$(date +%Y%m%d%H%M%S).p7b"
	echo "* Downloading p7b file:"
	echo "  $p7b"
	echo

	[ -z "$orderNumber" ] && die "no order number"
	curl "https://cert-manager.com/api/smime/v1/collect/$orderNumber" -s -X GET \
	    -H "customerUri: $customer" \
	    -H "login: $admin_user" \
	    -H "password: $admin_pass" \
		> $p7b
	;&

print-result)	#-- Print result of last api test
	[ -n "$p7b"       ] || p7b=$(ls -1 "$prefix/data/$email"-*.p7b | tail -1)
	[ -n "$csr_email" ] || csr_emails=( $(openssl req -in "$csr" -noout -text | grep-alt-emails) )

	p7b_emails=( $(openssl pkcs7 -inform PEM -outform PEM -in "$p7b" -print_certs | openssl x509 -text -noout | grep-alt-emails) )

	echo "* Compare e-mail addesses:"
	echo "  $p7b"
	echo
	echo "  Wanted: ${emails[@]}"
	echo "  CSR:    ${csr_emails[@]}"
	echo "  P7B:    ${p7b_emails[@]}"
	;;


print-p7b)	#-- Print content of last p7b
	p7b=$(ls -1 "$prefix/data/$email"-*.p7b | tail -1)
	echo "* P7b file:"
	echo "  $p7b"
	echo
	openssl pkcs7 -inform PEM -outform PEM -in "$p7b" -print_certs | openssl x509 -text -noout | less
	;;

convert-pfx)	#-- Convert p7b to pfx
	p7b=$(ls -1 "$prefix/data/$email"-*.p7b | tail -1)
	p12="${p7b%.p7b}.p12"
	cer="${p7b%.p7b}.cer"
	key="${p7b%-*}.key"
	cacert="${p7b%.p7b}-cacert.cer"
	echo "* P12 file:"
	echo "  $p12"
	echo
	openssl pkcs7 -inform PEM -outform PEM -in "$p7b" -print_certs -out "$cer"
	awk -F= '$1=="subject"{i++}i>1' "$cer" >"$cacert"
	openssl pkcs12 -export -in "$cer" -inkey "$key" -out "$p12" -certfile "$cacert" -passin "pass:$pass" -passout "pass:$pass"
	;;

*)
	echo "Error: ${1:-missing command}" >&2
	echo >&2
	grep -F -- '#''-- ' $0 | sed 's/)[ 	]*#--/	-- /' >&2
	;;

esac


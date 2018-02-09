for p in $(cat passphrase.req)
do
  export PP_VALUE=$(openssl rand -hex 10)
  export PP_NAME=$p
  envsubst < passphrase.sub > ${p}.yaml
done

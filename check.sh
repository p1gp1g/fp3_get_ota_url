#!/bin/sh

ORI_BUILD="8901.2.A.0105.20191217"
ORI_INCREMENTAL="12171325"
ORI_DATE="2019-12-05"

URL="https://android.googleapis.com/checkin"

POST_DATA="post_data.gz"
OUT="output"

[ -f ${OUT} ] && rm ${OUT}

echo "Getting OTA URL from BUILD ${ORI_BUILD}/${ORI_INCREMENTAL} (${ORI_DATE})"

curl -H "Content-type: application/x-protobuffer" \
     -H "Content-encoding: gzip" \
     -H "Accept-Encoding: gzip, deflate" \
     -H "User-Agent: Dalvik/2.1.0 (Linux; U; Android 9; FP3 Build/${ORI_BUILD})" \
     -H "Expect:" \
     -X POST \
     --data-binary "@${POST_DATA}" \
     --ignore-content-length \
     --output "${OUT}.gz" \
     -s "$URL" || exit 1

gzip -d ${OUT}.gz

strings ${OUT} | grep -A1 update_title | tail -n1
strings ${OUT} | grep -A1 "update_url" | tail -n1 | sed 's/^.\(.*\)..$/\1/g'

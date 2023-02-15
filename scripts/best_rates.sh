#!/bin/zsh

function callApi() {
  L_MARKET_VALUE=$1
  L_MORTGAGE_AMOUNT=$2
#  echo "MV=$L_MARKET_VALUE MA=$L_MORTGAGE_AMOUNT"
  result=$(curl 'https://www.sbab.se/api/interest-service/api/v1/interest/difference/market/mortgage' \
  -H 'Accept: */*' \
  -H 'Accept-Language: sv-SE,sv;q=0.9,en-US;q=0.8,en;q=0.7,ru;q=0.6' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H 'Cookie: sv-uts=N2MwNGU0ODAtMjQ1Yy0xMWVkLWEyYjctMDA1MDU2YTFiZjAwIzIjMTY2MTQyMTUxNTQ2NA==; JSESSIONID=5AA0C9F167E6C1D6F5EA0123BC7C4A2B; BIGipServer~sbb~sbb-vip-p-www=rd1o00000000000000000000ffff0a2a8c04o443; _cmp_settings=227b5c22615c223a747275652c5c226d5c223a747275652c5c22665c223a747275657d22' \
  -H 'DNT: 1' \
  -H 'Origin: https://www.sbab.se' \
  -H 'Referer: https://www.sbab.se/1/privat/vara_rantor.html' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  --data-raw "{\"marketValue\":${L_MARKET_VALUE},\"mortgageAmount\":${L_MORTGAGE_AMOUNT},\"realEstateEnergyClass\":\"A\"}" \
  --compressed --silent | jq -r '.priceDifference')
  echo "$result"
}

function top2500() {
  MARKET_VALUE=2500000
  printf "Discount\tMortgage Amount\tMarket Value\tLTV\n" > result_2500.csv
  for MA_CUR in {900000..2500000..50000}
    do
       disc=$(callApi $MARKET_VALUE $MA_CUR)
       ltv=$(((100*MA_CUR)/$MARKET_VALUE))
       #echo "$disc at $MA_CUR ltv=$ltv"
       printf "$disc\t${MA_CUR}\t${MARKET_VALUE}\t${ltv}\n" >> result_2500.csv
  done
  #ccat result_2500.csv

  top5rates=$(tail -n +2 result_2500.csv| sort -k1 -r | head -n 5)
  echo "top5:\n$top5rates\n"

  worstTop5rates=$(tail -n +2 result_2500.csv| sort -k1 -r | tail -n 5)
  echo "anti-top5:\n$worstTop5rates\n"
  gnuplot -e "set grid; set term png; set xrange [20:110]; set yrange [-0.7:0.0]; set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2 pointtype 7 pointsize 1.5; plot 'result_2500.csv' using 4:1 with linespoints linestyle 1;" > plot_2500.png;
}

top2500

function top3500() {
  MARKET_VALUE=3500000
  printf "Discount\tMortgage Amount\tMarket Value\tLTV\n" > result_3500.csv
  for MA_CUR in {900000..3500000..50000}
    do
       disc=$(callApi $MARKET_VALUE $MA_CUR)
       ltv=$(((100*MA_CUR)/$MARKET_VALUE))
       #echo "$disc at $MA_CUR ltv=$ltv"
       printf "$disc\t${MA_CUR}\t${MARKET_VALUE}\t${ltv}\n" >> result_3500.csv
  done
  #ccat result_3500.csv

  top5rates=$(tail -n +2 result_3500.csv| sort -k1 -r | head -n 5)
  echo "top5:\n$top5rates\n"

  worstTop5rates=$(tail -n +2 result_3500.csv| sort -k1 -r | tail -n 5)
  echo "anti-top5:\n$worstTop5rates\n"

  gnuplot -e "set grid; set term png; set xrange [20:110]; set yrange [-0.7:0.0]; set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2 pointtype 7 pointsize 1.5; plot 'result_3500.csv' using 4:1 with linespoints linestyle 1;" > plot_3500.png;
}

top3500
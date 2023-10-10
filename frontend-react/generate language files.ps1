

write-host "Running..."

# npm run extract -- 'src/**/*.js' --out-file lang/en.json --id-interpolation-pattern '[sha512:contenthash:base64:6]'
npm run extract -- 'src/**/*.js' --out-file lang/ru.json --id-interpolation-pattern '[sha512:contenthash:base64:6]'


# ([а-яА-Яё]+([ \?]+[а-яА-Яё]+)*)

# <FormattedMessage id='$1' defaultMessage="$1"/>

# (["'`])([^а-яА-Яё"]*)([а-яА-Яё]+([ \?]+[а-яА-Яё]+)*)(["'`])
# (["'`])([а-яА-Яё]+([ \?]+[а-яА-Яё]+)*)(["'`])

# intl.formatMessage({id:`$2`,defaultMessage: `$2`})
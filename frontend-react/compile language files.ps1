

write-host "Running..."

npm run compile -- lang/en.json --ast --out-file src/compiled-lang/en.json
npm run compile -- lang/ru.json --ast --out-file src/compiled-lang/ru.json
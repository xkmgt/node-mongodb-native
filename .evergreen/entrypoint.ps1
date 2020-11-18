git clone --depth 1 -b v$env:DRIVER_VERSION $env:DRIVER_REPOSITORY driver_src
cd driver_src
npm install --silent
npx mocha --recursive test/functional test/unit

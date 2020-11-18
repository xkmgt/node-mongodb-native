git clone --depth 1 -b v$env:DRIVER_VERSION $env:DRIVER_REPOSITORY driver_src
cd driver_src
npm install --silent
# note: docker for windows doesn't support host networking
$env:MONGODB_URI = $env:MONGODB_URI -replace "localhost", "host.docker.internal"
[Environment]::SetEnvironmentVariable('PATH', $env:MONGODB_URI, [EnvironmentVariableTarget]::Machine); `
npx mocha --recursive test/functional test/unit

pushd hwi-tests

    poetry install

    pushd test
        ./setup_environment.sh
    popd

popd

python3 setup.py build_ext --inplace
rc=$?; if [[ $rc == 0 ]]; then
python3 -O -c 'import main;main.run()';
fi

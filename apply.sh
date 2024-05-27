#!/usr/bin/env bash
while getopts a:n:u:d: flag
do
    case "${flag}" in
        a) author=${OPTARG};;
        n) name=${OPTARG};;
        u) urlname=${OPTARG};;
        d) description=${OPTARG};;
    esac
done

echo "Author: $author";
echo "Project Name: $name";
echo "Project URL name: $urlname";
echo "Description: $description";

echo "Rendering the Flask template..."
original_author="tuna7588"
original_name="fp64_anhtunguyen_familystaticflask"
original_urlname="fp64-anhtunguyen-FamilyStaticFlask"
original_description="Awesome fp64_anhtunguyen_familystaticflask created by tuna7588" 
TEMPLATE_DIR="./.github/templates/flask"
for filename in $(find ${TEMPLATE_DIR} -name "*.*" -not \( -name "*.git*" -prune \) -not \( -name "apply.sh" -prune \)) 
do
    sed -i "s/$original_author/$author/g" $filename
    sed -i "s/$original_name/$name/g" $filename
    sed -i "s/$original_urlname/$urlname/g" $filename
    sed -i "s/$original_description/$description/g" $filename
    echo "Renamed $filename"
done

# Add requirements
if [ ! -f pyproject.toml ]
then
    cat ${TEMPLATE_DIR}/requirements.txt >> requirements.txt
    cat ${TEMPLATE_DIR}/requirements-test.txt >> requirements-test.txt
else
    for item in $(cat ${TEMPLATE_DIR}/requirements.txt)
    do
        poetry add "${item}"
    done
    for item in $(cat ${TEMPLATE_DIR}/requirements-test.txt)
    do
        poetry add --dev "${item}"
    done
fi

# Move module files
rm -rf "${name}"
rm -rf tests
cp -R ${TEMPLATE_DIR}/fp64_anhtunguyen_familystaticflask "${name}"
cp -R ${TEMPLATE_DIR}/tests tests

cp ${TEMPLATE_DIR}/README.md README.md
cp ${TEMPLATE_DIR}/Containerfile Containerfile
cp ${TEMPLATE_DIR}/wsgi.py wsgi.py
cp ${TEMPLATE_DIR}/.env .env
cp ${TEMPLATE_DIR}/settings.toml settings.toml

# install
make clean

if [ ! -f pyproject.toml ]
then
    make virtualenv
    make install
    echo "Applied Flask template"
    echo "Ensure you activate your env with 'source .venv/bin/activate'"
    echo "then run 'fp64_anhtunguyen_familystaticflask' or 'python -m fp64_anhtunguyen_familystaticflask'"
else
    poetry install
    echo "Applied Flask template"
    echo "Ensure you activate your env with 'poetry shell'"
    echo "then run 'fp64_anhtunguyen_familystaticflask' or 'python -m fp64_anhtunguyen_familystaticflask' or 'poetry run fp64_anhtunguyen_familystaticflask'"
fi

echo "README.md has instructions on how to use this Flask application."

FROM python:3.7-alpine
COPY . /app
WORKDIR /app
RUN pip install .
RUN fp64_anhtunguyen_familystaticflask create-db
RUN fp64_anhtunguyen_familystaticflask populate-db
RUN fp64_anhtunguyen_familystaticflask add-user -u admin -p admin
EXPOSE 5000
CMD ["fp64_anhtunguyen_familystaticflask", "run"]

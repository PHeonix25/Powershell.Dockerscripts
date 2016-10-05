# The "base image":
FROM starefossen/github-pages 

# This should be you:
MAINTAINER Pat Hermens <p@hermens.com.au> 

# Don't forget to copy all required files
COPY . /usr/src/app 

# And open any required ports
EXPOSE 4000/tcp 
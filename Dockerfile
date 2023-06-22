# Docker image with PYTHON3 and DEPENDENCES for pyodbc with MS ODBC 17 DRIVER, Debian GNU/Linux 11 (bullseye)
# Cloned from TADEO RUBIO
# Using the official Python image, Tag 3.10.12-bullseye
FROM python:3.10.12-bullseye

# UPDATE APT-GET
RUN apt-get update

# PYODBC DEPENDENCES
RUN apt-get install -y tdsodbc unixodbc-dev
RUN apt install unixodbc -y
RUN apt-get clean -y
ADD odbcinst.ini /etc/odbcinst.ini

# UPGRADE pip3
RUN pip3 install --upgrade pip

# CHANGE openssl
RUN chmod +rwx /etc/ssl/openssl.cnf
RUN sed -i 's/TLSv1.2/TLSv1/g' /etc/ssl/openssl.cnf
RUN sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /etc/ssl/openssl.cnf

# DEPENDECES FOR DOWNLOAD ODBC DRIVER
RUN apt-get install apt-transport-https 
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update

# INSTALL ODBC DRIVER
RUN ACCEPT_EULA=Y apt-get install msodbcsql17 --assume-yes

# CONFIGURE ENV FOR /bin/bash TO USE MSODBCSQL17
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile 
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc 

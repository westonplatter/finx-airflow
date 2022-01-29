FROM continuumio/miniconda3

ENV PYTHONDONTWRITEBYTECODE 0
ENV SLUGIFY_USES_TEXT_UNIDECODE yes

# core os packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    gcc \
    g++ \
    libsasl2-dev \
    libpq-dev \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    dumb-init \
    freetds-bin \
    gosu \
    # krb5-user \
    ldap-utils \
    # libffi6 \
    libldap-2.4-2 \
    libsasl2-2 \
    libsasl2-modules \
    libssl1.1 \
    locales  \
    lsb-release \
    netcat \
    openssh-client \
    postgresql-client \
    procps \
    rsync \
    sasl2-bin \
    # sqlite3 \
    sudo \
    unixodbc \
    vim

# base layer conda dependencies
RUN conda install -y -q python=3.9 mkl=2022.0.1
COPY dependencies dependencies
RUN set -x && \
  conda env update --name base --file dependencies/environment.yml && \
  pip install \
    apache-airflow[async,aws,azure,crypto,hdfs,hive,password,postgres,jdbc,ssh]==1.10.15 \
    dask \
    --no-cache-dir \
    --constraint 'https://raw.githubusercontent.com/apache/airflow/constraints-1.10.15/constraints-3.7.txt' && \
  apt-get remove -y --purge gcc g++ && \
  apt autoremove -y && \
  apt-get clean -y

COPY entrypoint.sh /scripts/
RUN chmod +x /scripts/entrypoint.sh

WORKDIR /root/airflow
VOLUME ["/root/airflow/dags", "/root/airflow/logs"]

ENTRYPOINT ["/scripts/entrypoint.sh"]
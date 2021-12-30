FROM conda/miniconda3 AS builder

# Make sure noninteractive debian install is used and language variables set
ENV DEBIAN_FRONTEND=noninteractive LANGUAGE=C.UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    LC_CTYPE=C.UTF-8 LC_MESSAGES=C.UTF-8

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
	apt-transport-https \
	apt-utils \
	build-essential \
	ca-certificates \
	curl \
	dumb-init \
	freetds-bin \
	freetds-dev \
	gnupg2 \
	ldap-utils \
	libffi-dev \
	libkrb5-dev \
	libldap2-dev \
	libpq-dev \
	libsasl2-2 \
	libsasl2-dev \
	libsasl2-modules \
	libssl-dev \
	openssh-client \
	postgresql-client \
	software-properties-common \
	sqlite3 \
	sudo \
	unixodbc \
	unixodbc-dev \
	yarn \
    && apt-get autoremove -yqq --purge \
    && apt-get clean


FROM builder AS airflow
COPY environment.yml environment.yml
RUN conda env update --name base --file environment.yml

ARG AIRFLOW_HOME=/opt/airflow
ARG AIRFLOW_UID="50000"
ARG AIRFLOW_USER_HOME_DIR=/home/airflow

WORKDIR ${AIRFLOW_HOME}


# fix permission issue in Azure DevOps when running the scripts
RUN adduser \
	--quiet "airflow" \
	--uid "${AIRFLOW_UID}" \
	--gid "0" \
	--home "${AIRFLOW_USER_HOME_DIR}" && \
    # Make Airflow files belong to the root group and are accessible.
    # This is to accommodate the guidelines from OpenShift
    # https://docs.openshift.com/enterprise/3.0/creating_images/guidelines.html
    mkdir -pv "${AIRFLOW_HOME}"; \
    mkdir -pv "${AIRFLOW_HOME}/dags"; \
    mkdir -pv "${AIRFLOW_HOME}/logs"; \
    chown -R "airflow:root" "${AIRFLOW_USER_HOME_DIR}" "${AIRFLOW_HOME}"; \
    find "${AIRFLOW_HOME}" -executable -print0 | xargs --null chmod g+x && \
        find "${AIRFLOW_HOME}" -print0 | xargs --null chmod g+rw

#COPY --chown=airflow:root --from=airflow-build-image /root/.local "${AIRFLOW_USER_HOME_DIR}/.local"
COPY --chown=airflow:root airflow/entrypoint.sh /entrypoint
COPY --chown=airflow:root airflow/clean-logs.sh /clean-logs

# Make /etc/passwd root-group-writeable so that user can be dynamically added by OpenShift
# See https://github.com/apache/airflow/issues/9248

RUN chmod a+x /entrypoint /clean-logs && \
    chmod g=u /etc/passwd

RUN usermod -g 0 airflow -G 0
USER ${AIRFLOW_UID}

EXPOSE 8080

# See https://airflow.apache.org/docs/docker-stack/entrypoint.html#signal-propagation
# to learn more about the way how signals are handled by the image
ENV DUMB_INIT_SETSID="1"

# This one is to workaround https://github.com/apache/airflow/issues/17546
# issue with /usr/lib/x86_64-linux-gnu/libstdc++.so.6: cannot allocate memory in static TLS block
# We do not yet a more "correct" solution to the problem but in order to avoid raising new issues
# by users of the prod image, we implement the workaround now.
# The side effect of this is slightly (in the range of 100s of milliseconds) slower load for any
# binary started and a little memory used for Heap allocated by initialization of libstdc++
# This overhead is not happening for binaries that already link dynamically libstdc++
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libstdc++.so.6"

RUN mkdir -p /home/airflow/airflow
COPY airflow/airflow.cfg /home/airflow/airflow/airflow.cfg

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint"]
CMD []

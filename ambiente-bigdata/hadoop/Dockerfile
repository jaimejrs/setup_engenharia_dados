FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Dependências básicas + Java + SSH (necessários para o Hadoop pseudo-distribuído)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        python3-pip python3-dev libmysqlclient-dev libssl-dev nano sudo \
        curl wget vim git net-tools zip unzip bzip2 rsync gcc make perl \
        openjdk-11-jdk openssh-server openssh-client && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_VERSION=3.3.6
ENV HADOOP_DOWNLOAD_URL=https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

# Baixa e extrai o Hadoop
RUN wget -q "${HADOOP_DOWNLOAD_URL}" -O /tmp/hadoop.tar.gz && \
    tar -xf /tmp/hadoop.tar.gz -C /opt/ && \
    mv /opt/hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
    rm /tmp/hadoop.tar.gz

# SSH sem senha para localhost (exigido mesmo em modo pseudo-distribuído)
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Configurações do Hadoop
COPY config/core-site.xml ${HADOOP_CONF_DIR}/core-site.xml
COPY config/hdfs-site.xml ${HADOOP_CONF_DIR}/hdfs-site.xml
COPY config/mapred-site.xml ${HADOOP_CONF_DIR}/mapred-site.xml
COPY config/yarn-site.xml ${HADOOP_CONF_DIR}/yarn-site.xml

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> ${HADOOP_CONF_DIR}/hadoop-env.sh && \
    echo 'export HADOOP_SSH_OPTS="-o StrictHostKeyChecking=no -o ConnectTimeout=2"' >> ${HADOOP_CONF_DIR}/hadoop-env.sh

RUN mkdir -p ${HADOOP_HOME}/data/nn ${HADOOP_HOME}/data/dn ${HADOOP_HOME}/logs

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9870 8020 9864 9866 9867 8088 8042 19888

ENTRYPOINT ["/entrypoint.sh"]

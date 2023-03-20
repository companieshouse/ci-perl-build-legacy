# git_key=$(ssh -G github.com 2>/dev/null |sed -n '/identityfile/{s/.* \(.*\)/\1/; s|~|'$HOME'|; p;}') && \
# eval $(ssh-agent) && ssh-add ${git_key} && \
# docker buildx build -t chl_base_git --ssh default=$SSH_AUTH_SOCK .

FROM centos:6.7
ARG home=/root
ARG alphagov_templ=https://github.com/alphagov/govuk_template.git

RUN sed -i '/^mirrorlist/s/^/#/;/^#baseurl/{s/#//;s/mirror.centos.org\/centos\/$releasever/linuxsoft.cern.ch\/centos-vault\/6.7/}' /etc/yum.repos.d/CentOS-Base.repo

RUN yum install -y \
    git

RUN printf '[url "git@github.com:"]\n  insteadOf = "https://github.com/"\n' > ${home}/.gitconfig \
    && mkdir -p -m 0700 ${home}/.ssh && ssh-keyscan github.com >> ${home}/.ssh/known_hosts

RUN --mount=type=ssh git clone ${alphagov_templ}

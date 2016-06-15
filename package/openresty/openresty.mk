################################################################################
#
# openresty
#
################################################################################

OPENRESTY_VERSION = 1.9.7.4
OPENRESTY_SITE = https://openresty.org/download
OPENRESTY_DEPENDENCIES += pcre openssl
OPENRESTY_LICENSE = BSD-2c
OPENRESTY_LICENSE_FILES = LICENSE
OPENRESTY_CFLAGS = "-v"
OPENRESTY_CPP_FLAGS = "-E"
OPENRESTY_CONF_OPTS = \
        --crossbuild=Linux::$(BR2_ARCH) \
        --with-cc="$(TARGET_CC)" \
        --with-cpp="$(TARGET_CPP)" \
        --with-cc-opt="-pipe -O -W -Wall -g -O2" \
        --with-ld-opt="$(TARGET_LDFLAGS)" \
        --with-ipv6



# disable external libatomic_ops because its detection fails.
OPENRESTY_CONF_ENV += \
        ngx_force_c_compiler=yes \
        ngx_force_c99_have_variadic_macros=yes \
        ngx_force_gcc_have_variadic_macros=yes \
        ngx_force_gcc_have_atomic=yes \
        ngx_force_have_libatomic=no \
        ngx_force_have_epoll=yes \
        ngx_force_have_sendfile=yes \
        ngx_force_have_sendfile64=yes \
        ngx_force_have_pr_set_dumpable=yes \
        ngx_force_have_timer_event=yes \
        ngx_force_have_map_anon=yes \
        ngx_force_have_map_devzero=yes \
        ngx_force_have_sysvshm=yes \
        ngx_force_have_posix_sem=yes

# prefix: nginx root configuration location
OPENRESTY_CONF_OPTS += \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/lock/nginx.lock \
        --error-log-path=/var/log/nginx/error.log \
        --user=nobody \                                                        
        --group=nogroup \ 
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/var/tmp/nginx/client-body \
        --http-proxy-temp-path=/var/tmp/nginx/proxy \
        --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
        --http-scgi-temp-path=/var/tmp/nginx/scgi \
        --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi


define OPENRESTY_CONFIGURE_CMDS
	cd $(@D); $(OPENRESTY_CONF_ENV) $(@D)/configure $(OPENRESTY_CONF_OPTS) 
endef 

define OPENRESTY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) 
endef

define OPENRESTY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
        $(RM) $(TARGET_DIR)/usr/sbin/nginx.old \
		$(TARGET_DIR)/usr/local/openresty/luajit/share/man/man1/luajit.1
endef

$(eval $(generic-package))

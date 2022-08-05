#!/usr/bin/env sh 

server() { 

echo -n "
# ssdb-server config
# MUST indent by TAB!

# absolute path, or relative to path of this file, directory must exists
work_dir = /var/lib/ssdb
pidfile = /dev/shm/ssdb.pid

server:
	# specify an ipv6 address to enable ipv6 support
	ip: ${IP:-0.0.0.0}
	port: ${PORT:-8888}
	# format: allow|deny: all|ip_prefix
	# multiple allows or denys is supported
	#deny: all
	#allow: 127.0.0.1
	#allow: 192.168
	# auth password must be at least 32 characters
	#auth: very-strong-password
	#readonly: yes
	# in ms, to log slowlog with WARN level
	#slowlog_timeout: 5

replication:
	binlog: yes
	# Limit sync speed to *MB/s, -1: no limit
	sync_speed: -1
	slaveof:
		# to identify a master even if it moved(ip, port changed)
		# if set to empty or not defined, ip: 0.0.0.0
		#id: svc_2
		# sync|mirror, default is sync
		#type: sync
		#host: localhost
		#port: 8889

logger:
	level: info
	output: stdout
	rotate:
		size: 1000000000

leveldb:
	# Compression yes|no
	compression: yes
	# Compaction Speed in MB/s
	compaction_speed: ${COMPACTION_SPEED:-1000}
	# Cache in MB
	cache_size: ${CACHE_SIZE:-512}
	# Wirte Buffer in MB
	write_buffer_size: ${WRITE_BUFFER_SIZE:-512}
	# Max open files
	max_open_files: ${MAX_OPEN_FILES:-99999}
" > /usr/local/ssdb/ssdb.conf

	## Launch
	exec /usr/local/ssdb/ssdb-server /usr/local/ssdb/ssdb.conf
}

if [ "$1" = 'server' ]; then
	server
else
	exec "$@"
fi

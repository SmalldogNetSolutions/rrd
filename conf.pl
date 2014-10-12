if (not -e "$ENV{HTTPD_ROOT}/logs/rrd") {
    die "Need '$ENV{HTTPD_ROOT}/logs/rrd' for logging.";
}

# now put it all together
my $common = <<END;
    Errorlog        logs/rrd/error_log
    CustomLog       logs/rrd/access_log sdnfw
    DocumentRoot    "/data/rrd/content"
    DirectoryIndex  index.html
	PerlPassEnv		HTTPD_ROOT
    PerlSetVar  	HTTPD_ROOT $ENV{HTTPD_ROOT}
	SetEnv			HTMLDOC_NOCGI yes
	SetEnv			BASE_URL /
	SetEnv			OBJECT_BASE rrd
	SetEnv			APACHE_SERVER_NAME $ENV{APACHE_SERVER_NAME}
	SetEnv			IP_ADDR $ENV{IP_ADDR}
END

my %config;
if (-f "$ENV{HTTPD_ROOT}/conf/rrd.conf") {
	open F, "$ENV{HTTPD_ROOT}/conf/rrd.conf";
	while (my $l = <F>) {
		chomp $l;
		next if ($l =~ m/^#/);
		if ($l =~ m/^([^=]+)=(.+)$/) {
			$common .= "	SetEnv	$1	$2\n";
			$config{$1} = $2;
		}
	}
	close F;
}

$common .= <<END;
    PerlRequire 	"$ENV{HTTPD_ROOT}/rrd/startup.pl"

	ServerName		$config{SERVER_NAME}

	<Location />
		SetHandler		perl-script
    	PerlHandler     Apache::SdnFw
	</Location>

	Options -Indexes

	RewriteEngine	on
	RewriteRule ^(.+)-r[0-9]+(\.[^/]+)\$	\$1\$2	[R]
END

print <<END;
<VirtualHost $ENV{IP_ADDR}:$ENV{HTTP_PORT}>
$common
</VirtualHost>
END

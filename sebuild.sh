#!/bin/sh
rm loadpath.se
cp loadpath.se.linux loadpath.se
compile -case_insensitive $ECLI/spec/se/linux/libecli_c.a /usr/local/lib/libodbc.a -ldl e_cli_db make 
echo "Done !"


[Cluster]
Name=ECLI
Category=DB Access
Sources=ECLI.Sources
Bindings=ECLI.Bindings

[ECLI.Sources]
ECLI.Sources.data=
ECLI.Sources.pattern=
ECLI.Sources.abstract=
ECLI.Sources.spec=
ECLI.Sources.spec.ve=

[ECLI.Sources.data]
Mask=data/*.e

[ECLI.Sources.pattern]
Mask=pattern/*.e

[ECLI.Sources.abstract]
Mask=abstract/*.e

[ECLI.Sources.spec]
Mask=spec/*.e

[ECLI.Sources.spec.ve]
Mask=spec/ve/*.e


[ECLI.Bindings]
Clusters=ECLI.Clusters
Systems=ECLI.Systems

[ECLI.Clusters]
VE.Kernel=

[VE.Kernel]
Name=Kernel
Path=$VE_Lib/Kernel

[ECLI.Systems]
ECLI.System=

[ECLI.System]
Link_options=ECLI.Link_options.$VE_OS

[ECLI.Link_options.Win32]
$ECLI\src\spec\ve\windows\ecli_c.lib=

[ECLI.Link_options.Linux]
-L$ECLI/src/spec/ve/linux=
-lecli_c=
-lodbc=


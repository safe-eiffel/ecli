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

[ECLI.Clusters]
VE.Kernel=
VE.Pool=
VE.gArgs=
VE.WinLib=
VE.TimeDate=

[VE.Kernel]
Name=Kernel
Path=$VE_Lib/Kernel

[VE.Pool]
Name=Pool
Path=$VE_LIB/Misc/Pool

[VE.gArgs]
Name=gArgs
Path=$VE_LIB/Tools/gArgs

[VE.WinLib]
Name=WinLib
Path=$VE_LIB/WinLibs/WinLib

[VE.TimeDate]
Name=TimeDate
Path=$VE_LIB/TimeDate

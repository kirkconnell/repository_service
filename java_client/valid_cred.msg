-----BEGIN MPKI CREDENTIAL-----

-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvC+m32GusrDvN5tQyAlr7SEcg
cyNTfLSHG14bgX2CQzz6z5saoYGZWI3blurN4M+yTLlYEQGcI5bqqoFy40V7b2UF
+UtU7hlXF+0041qDgN6iQGca19mizpBsdHycYgR4NaXcEt1P3JNOczX9HDTqdXSP
1wECQ1TmlDRLCFoqSwIDAQAB
-----END PUBLIC KEY-----

-----BEGIN MPKI CERTIFICATE-----

allow(PK, Access, Resources) :-
	    pk_bind(P, PK),
	    allow(P, Access, Resources).

pk_bind(jeremiah, rsa_3fcb4a57240d9287e43b8615e9994bba).

allow(jeremiah, read, file1).

allow(jeremiah, _anyAccess, file2).

allow(jeremiah, read, file3).

-----BEGIN VALIDITY-----
Not before: datime(2009,10,12,0,0,0).
Not after: datime(2009,12,19,0,0,0).
-----END VALIDITY-----

-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTbNDfI2DSfnx8xSnwkGk+NOVC
LogsoOUJR1bQkBzHtwOjtE8Sg2Qle4TnMQh9tD9z2B4ttmv7nKxynZz/x7R5AdtS
3YeX+WmF08DylUcfa86bNj+Kz3pzwqiCPZ1rwUpJC5vWifcXtv1rq6/gr6StL91v
HMhjU16DcxfI9ezLzwIDAQAB
-----END PUBLIC KEY-----

-----BEGIN SIGNATURE-----
ZCBz6Qf0REbIqMpeQT2PP8ngJjcNxnLbZuVljG3wCtI7/Ur8B8Qrd6uz8pqY5RWF
X9GQMpNS+lRylAVYSGMD2MgypaIE1Cz0sGMkTJ4g7y4BHoalK8lqGPA1LsXeyUwZ
9hBTCWGChUypFWdf3MlXxGLfhya6cNRJuEuXD1YKv7g=
-----END SIGNATURE-----

-----END MPKI CERTIFICATE-----

-----END MPKI CREDENTIAL-----

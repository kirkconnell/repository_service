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
vRHnMGC6qfc2jQj3y3IL/1XPRAUnlgqbE+7tkEFtYhQAisi10jwsXZgo+ncjtpGT
FaiV88oer+Ln4ZGdcHFYLI0qziyPZf4RQ5tGxKdQ8OB/EY0jcb8mf2iciWZOKb71
mM313kcz3oDaX0tF/OVI3mDnU58cF2rvw6ITIXKdTYI=
-----END SIGNATURE-----

-----END MPKI CERTIFICATE-----

-----END MPKI CREDENTIAL-----

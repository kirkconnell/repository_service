#r = `echo halt. | xsb -e "[sample],allow(rsa_3fcb4a57240d9287e43b8615e9994bba,read,file1)."`
#p r

p "| ?- | ?- \nyes\n| ?- \n| ?- " === /[.|\n]*yes[.|\n]*/


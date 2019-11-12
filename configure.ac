AC_INIT(ocaml-mysql,1.2.3)

AC_CHECKING([for ocaml compiler and tools])
AC_CHECK_PROG(ocamlc,ocamlc,ocamlc)
AC_CHECK_PROG(ocamlopt,ocamlopt,ocamlopt)
AC_CHECK_PROG(ocamlfind,ocamlfind,ocamlfind)

AC_MSG_CHECKING([whether ocamlopt supports natdynlink])
AS_IF([`grep -q "NATDYNLINK=true" $(ocamlc -where)/Makefile.config`],[CAN_NATDYNLINK=yes],[CAN_NATDYNLINK=no])
AC_MSG_RESULT([$CAN_NATDYNLINK])
AC_SUBST(CAN_NATDYNLINK)

AC_PROG_INSTALL
AC_SUBST(INSTALL)

AC_CHECKING([for C compiler])
AC_PROG_CC()

AC_CHECKING([for C header files])
AC_HEADER_STDC()

AC_MSG_CHECKING([for mysql includes])
# pkg-config as last resort because debian buster pkg-config flags are wrong
MYSQL_INCLUDE=`mysql_config --include || mariadb_config --include || pkg-config mariadb --cflags`
AS_IF([ test "$?" -eq 0 ],[CPPFLAGS="$MYSQL_INCLUDE $CPPFLAGS"],)
AC_MSG_RESULT([$MYSQL_INCLUDE])

AC_MSG_CHECKING([for mysql libraries])
MYSQL_LINK_FLAGS=`mysql_config --libs || mariadb_config --libs || pkg-config mariadb --libs`
AS_IF([ test "$?" -eq 0 ],[LDFLAGS="$MYSQL_LINK_FLAGS $LDFLAGS"],)
AC_MSG_RESULT([$MYSQL_LINK_FLAGS])

AC_CHECK_HEADERS([mysql.h mysql/mysql.h], [break])
if test "$ac_cv_header_mysql_mysql_h" != "yes" -a "$ac_cv_header_mysql_h" != "yes"; then
    AC_MSG_ERROR([mysql.h not found])
fi

AC_CONFIG_HEADERS([config.h])
AC_OUTPUT(Makefile)
AC_OUTPUT(VERSION)

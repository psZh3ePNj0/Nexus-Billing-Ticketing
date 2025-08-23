::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::								                            ::
:: Author: Christophe Cartwright				            ::
:: Dept: Apps & Dev, IT         				            ::
:: Batch Script: BOUNCE_NEXUS_Service.bat			        ::
:: Description: This script bounces the NEXUS_Service	    ::
:: Use when appropriate                                     ::
::								                            ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO OFF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::Commands below stops and starts the NEXUS Service

NET STOP	"_NEXUS Service"
NET START	"_NEXUS Service"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
exit
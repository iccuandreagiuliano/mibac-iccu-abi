<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" />

	<!-- qualcosa nei servizi, poco più di orario, il resto è difficile da usare -->
	<xsl:template name="servizi">
		<xsl:element name="servizi">
			<xsl:if test="APERTURA/ORARIO">
				<xsl:element name="orario">
					<!-- le due righe sono necessarie perché l'orario ufficiale deve precedere 
						le variazioni (si assume che "invernale" significhi "ufficiale" -->
					<xsl:apply-templates
						select="APERTURA/ORARIO[@descrizione = 'Orario' or @descrizione = 'Orario annuale']" />
					<xsl:apply-templates
						select="APERTURA/ORARIO[not(@descrizione = 'Orario' or @descrizione = 'Orario annuale')]" />
					<xsl:apply-templates select="APERTURA/CHIUSURA" />
				</xsl:element>
			</xsl:if>

			<!-- Uno stesso template per i servizi viene invocato più volte sotto 
				condizioni diverse, e in punti diversi. Lo stesso template non è però adatto 
				alle sezioni speciali perché esse hanno un contenitore sia in input che in 
				output, e la molteplicità va gestita opportunamente -->

			<xsl:apply-templates select="SERVIZI/SERVIZIO[contains(., 'utomatizzato')]" />
			<!-- questa è stata una fatica: invoca il template solo se l'elemento 
				SERVIZIO contiene la stringa 'nformazion' (pare non funzionino "espressioni 
				regolari", quindi 'nformazion' è il massimo che si possa fare) -->
			<xsl:apply-templates select="SERVIZI/SERVIZIO[contains(., 'nformazion')]" />
			<xsl:element name="internet">
				<xsl:attribute name="attivo">s</xsl:attribute>
			</xsl:element>
			<xsl:if test="starts-with(APERTURA/CONDIZIONI, 'Aperta a Tutti')">
				<accesso>
					<aperta>s</aperta>
				</accesso>
			</xsl:if>
			<xsl:call-template name="sezioni-speciali" />
		</xsl:element>

	</xsl:template>
	<!-- qui il problema è ottenere per primo l'orario ufficiale, come previsto 
		dal formato ICCU; è stato risolto invocando due volte il template con @descrizione 
		diverse, vedi sopra -->
	<xsl:template match="//scheda_BIBLIO/APERTURA/ORARIO">
		<xsl:variable name="d" select="@descrizione" />
		<xsl:if test="$d = 'Orario' or $d = 'Orario annuale'">
			<ufficiale>
				<xsl:apply-templates select="GIORNO" />
			</ufficiale>
		</xsl:if>
		<xsl:if test="not($d = 'Orario' or $d = 'Orario annuale')">
			<variazione>
				<xsl:apply-templates select="GIORNO" />
				<note>
					<xsl:value-of select="$d" />
				</note>
			</variazione>
		</xsl:if>
	</xsl:template>
	<!-- qui la cosa più difficile è riportare i nomi dei giorni alle abbreviazioni 
		usate nel formato ICCU: la tecnica usata consiste nel prendere le prime tre 
		lettere e, in mancanza di una funzione "lower-case" introdotta solo in XPath 
		2.0, tradurre le sei possibili lettere maiuscole nelle rispettive minuscole; 
		il template va applicato solo dall'interno di un elemento "orario/ufficiale" 
		oppure "orario/variazione" dell'output -->
	<xsl:template match="//scheda_BIBLIO/APERTURA/ORARIO/GIORNO">
		<orario>
			<xsl:attribute name="giorno">
				<xsl:value-of select="translate(substring(@nome,1,3), 'LMGVSD', 'lmgvsd')" />
			</xsl:attribute>
			<xsl:attribute name="dalle"><xsl:value-of select="FASCIA/@dalle" /></xsl:attribute>
			<xsl:attribute name="alle"><xsl:value-of select="FASCIA/@alle" /></xsl:attribute>
		</orario>
	</xsl:template>

	<xsl:template match="//scheda_BIBLIO/APERTURA/CHIUSURA">
		<xsl:if test="normalize-space(.)">
			<chiusura>
				<note>
					<xsl:value-of select="normalize-space(.)" />
				</note>
			</chiusura>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//scheda_BIBLIO/SERVIZI/SERVIZIO">
		<xsl:if test="contains(., 'nformazion')">
			<informazioni-bibliografiche>
				<xsl:attribute name="attivo">s</xsl:attribute>
				<servizio-interno>s</servizio-interno>
			</informazioni-bibliografiche>
		</xsl:if>
		<xsl:if test="contains(., 'utomatizzato')">
			<prestito>
				<locale>
					<xsl:attribute name="attivo">s</xsl:attribute>
					<automatizzato>s</automatizzato>
				</locale>
			</prestito>
		</xsl:if>
	</xsl:template>

	<xsl:template name="sezioni-speciali">
		<xsl:if
			test="contains(SERVIZI/SERVIZIO, 'meroteca') or contains(SERVIZI/SERVIZIO, 'agazzi')">
			<sezioni-speciali>
				<xsl:for-each select="SERVIZI/SERVIZIO">
					<xsl:if test="contains(., 'meroteca')">
						<sezione>emeroteca</sezione>
					</xsl:if>
					<xsl:if test="contains(., 'agazzi')">
						<sezione>ragazzi</sezione>
					</xsl:if>
				</xsl:for-each>
			</sezioni-speciali>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
FROM solr:8

EXPOSE 8983

ARG CKAN_BRANCH="dev-v2.10"


# Enviroment
ENV SOLR_CORE ckan
ENV SOLR_USER ckan

ENV SOLR_CONFIG_DIR="/opt/solr/server/solr/configsets"
ENV SOLR_SCHEMA_FILE="$SOLR_CONFIG_DIR/ckan/conf/schema.xml"
ENV SOLR_CKAN_CORE="$SOLR_CONFIG_DIR/ckan/conf" 

USER root

# Create a CKAN configset by copying the default one
RUN cp -R $SOLR_CONFIG_DIR/_default $SOLR_CONFIG_DIR/ckan
RUN rm $SOLR_CKAN_CORE/managed-schema


# Update the schema
COPY ./configuraciones/schema.xml $SOLR_SCHEMA_FILE
COPY ./configuraciones/solrconfig.xml "$SOLR_CKAN_CORE/solrconfig.xml"
COPY ./configuraciones/core.properties ./var/solr/data/ckan/core.properties

# be able to read SOLR6 sintax
RUN sed -i '/<config>/a <schemaFactory class="ClassicIndexSchemaFactory"/>' "$SOLR_CKAN_CORE/solrconfig.xml"
RUN sed -i '/<initParams path="\/update\/\*\*">/,/<\/initParams>/ s/.*/<!--&-->/' "$SOLR_CKAN_CORE/solrconfig.xml"
RUN sed -i '/<processor class="solr.AddSchemaFieldsUpdateProcessorFactory">/,/<\/processor>/ s/.*/<!--&-->/' "$SOLR_CKAN_CORE/solrconfig.xml"

RUN chmod 644 $SOLR_SCHEMA_FILE 

USER solr

CMD ["sh", "-c", "solr-precreate ckan $SOLR_CONFIG_DIR/ckan"]




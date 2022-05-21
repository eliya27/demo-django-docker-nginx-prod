FROM python:3.8-alpine

ENV PATH="/scripts:${PATH}"

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache --virtual .temp gcc libc-dev linux-headers
RUN pip install -r /requirements.txt 
RUN apk del .temp

RUN mkdir /app
COPY ./app /app
WORKDIR /app
COPY ./scripts /scripts

RUN chmod +x /scripts/*

RUN mkdir -p /vol/web/media
RUN -p /vol/web/static

RUN adduser -D user
RUN chown -R user:user /vol

RUN chmod -R 755 /vol/web
USER user

CMD ["entrypoint.sh"]
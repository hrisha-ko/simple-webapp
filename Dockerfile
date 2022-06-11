FROM python:3.10.4-slim-buster as builder
#FROM python:3.11.0b1-alpine as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/home/user/.local/bin:${PATH}"

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc-4.9

#RUN useradd -m -r user && chown user /app

#USER user

RUN pip install --no-cache-dir --upgrade \
    pip \
    setuptools \
    wheel

COPY requirements.txt .

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# install dependencies to the local user directory (eg. /root/.local)

#RUN pip install --user -r requirements.txt

# second unnamed stage
FROM python:3.10.4-slim-buster

WORKDIR /app

#RUN useradd -m -r user && chown user /app
# copy only the dependencies installation from the 1st stage image
#COPY --from=builder /root/.local /root/.local
RUN addgroup --gid 1001 --system user && \
    adduser --no-create-home --shell /bin/false --disabled-password --uid 1001 --system --group user

COPY --from=builder --chown=user:user /app/wheels /wheels
COPY --from=builder --chown=user:user /app/requirements.txt .
COPY --chown=user:user ./app .

RUN pip install --no-cache-dir /wheels/*
# update PATH environment variable
ARG GIT_COMMIT_HASH
ENV GIT_COMMIT_HASH=${GIT_COMMIT_HASH:-dev}

#RUN --mount=type=secret,id=mysecrets cat /run/secrets/mysecrets

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD timeout 10s bash -c ':> /dev/tcp/127.0.0.1/8000' || exit 1

CMD [ "python", "./script.py" ]

USER user

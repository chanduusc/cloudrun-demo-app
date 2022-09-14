FROM python:3.7-slim

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY src/ ./

# Install production dependencies.
RUN pip install -r requirements.txt

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.

# Twistlock Container Defender - app embedded
ADD ./twistlock_defender_app_embedded.tar.gz /
ENV DEFENDER_TYPE="appEmbedded"
ENV DEFENDER_APP_ID="cloudrub"
ENV FILESYSTEM_MONITORING="true"
ENV WS_ADDRESS="wss://us-east1.cloud.twistlock.com:443"
ENV DATA_FOLDER="/app"
ENV INSTALL_BUNDLE="eyJzZWNyZXRzIjp7InNlcnZpY2UtcGFyYW1ldGVyIjoiYjFVd2RpeUJKeUhqaGdiQjNrNGMvRTF4ejhIR3VMcExnNG9WTTNSc3pKcldMYzVMM1pTb0FlN2N0bEJjeEQzL2RhclJaclFjOHQ0Mlh5SkQ1WlVrS1E9PSJ9LCJnbG9iYWxQcm94eU9wdCI6eyJodHRwUHJveHkiOiIiLCJub1Byb3h5IjoiIiwiY2EiOiIiLCJ1c2VyIjoiIiwicGFzc3dvcmQiOnsiZW5jcnlwdGVkIjoiIn19LCJjdXN0b21lcklEIjoidXMtMi0xNTgyNTY4ODUiLCJhcGlLZXkiOiI5YlloWFMvTzIyKzhqNDQxTHFHcENCR1dvRlVtK3dzdHlZWjFvNnpEV29kV2dYa01JQXRiUUV3eDl6TmZYWEJNb1pRd1htYWszNXpyY1hCWkdMQ290dz09IiwibWljcm9zZWdDb21wYXRpYmxlIjpmYWxzZSwiaW1hZ2VTY2FuSUQiOiJhNDcwODhmYS02Y2EwLTJjMmMtOWM3NC0xYjViZWMzYzczOTUifQ=="
ENTRYPOINT exec /defender app-embedded  gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app

FROM gitpod/workspace-full

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /home/gitpod/flutter
ENV PATH="/home/gitpod/flutter/bin:/home/gitpod/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-download Flutter dependencies
RUN flutter precache

# Enable web
RUN flutter config --enable-web

FROM nextcloud

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN curl -fsSL 'https://github.com/cataphract/php-rar/archive/ab26d285759e4c917879967b09976a44829ed570.tar.gz' -o module-name.tar.gz \
	&& mkdir -p module-name \
	&& tar -xf module-name.tar.gz -C module-name --strip-components=1 \
	&& rm module-name.tar.gz \
	&& ( \
		cd module-name \
		&& phpize \
		&& ./configure --enable-module-name \
		&& make -j "$(nproc)" \
		&& make install \
	) \
	&& rm -r module-name \
	&& docker-php-ext-enable rar

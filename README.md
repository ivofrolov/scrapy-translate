# scrapy-translate: Scrapy pipeline to translate item fields

It's useful if you need to translate some text from parsed items into another language. But it is also suitable for other types of text processing.

## Usage

### Develop a translation service

The service should provide a mapping between the original and translated strings. The protocol is as follows.

``` python
class TranslationProvider(Protocol):
    async def translate(self, strings: Collection[str]) -> dict[str, str]: ...
```

### Develop a caching service (optionally)

This may help to reduce the number of strings that need to be translated. The protocol is as follows.

``` python
class CacheProvider(Protocol):
    async def get(self, strings: Collection[str]) -> dict[str, str]: ...

    async def set(self, strings: dict[str, str]) -> None: ...
```

### Add metadata to the item's class fields

The pipeline will only process the specified fields. Strings and lists of strings are supported as field values.

``` python
class Item(scrapy.Item):
    field = Field(translate=True)  # type: Union[str, list[str]]
```

It's also possible to translate HTML markup text while preserving the structure.

``` python
class Item(scrapy.Item):
    field = Field(translate=True, translate_html=True)
```

If you don't want certain field values to be cached, you can specify that.

``` python
class Item(scrapy.Item):
    field = Field(translate=True, translate_no_cache=True)
```

### Adjust project settings

Set the translation service class to the following setting.

``` python
TRANSLATION_PROVIDER = "myproject.services.MyTranslationProvider"
```

You can optionally set the caching service class. By default, there is no caching.

``` python
# TRANSLATION_CACHE_PROVIDER = "scrapy_pipeline.cache_providers.NullCacheProvider"
TRANSLATION_CACHE_PROVIDER = "myproject.services.MyCacheProvider"
```

And activate the pipeline.

``` python
ITEM_PIPELINES = {
    "scrapy_translate.pipelines.TranslatePipeline": 100,
}
```

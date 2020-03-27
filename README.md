# prestodb

Default prestodb version was 0.232.1 (latest) as of march 24 2020. But please update the PRESTO_VERSION

# To build coordinator node
``` docker build -t presto-coordinator --build-arg TYPE=coordinator . ```

# To build worker node
``` docker build -t presto-worker --build-arg TYPE=worker . ```

# To run image
``` docker run -itd -p 8080:8080 presto-coordinator ```

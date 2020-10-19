
## To enable groovy functions
https://stackoverflow.com/questions/38276341/jenkins-ci-pipeline-scripts-not-permitted-to-use-method-groovy-lang-groovyobjects
add ```
-e JAVA_OPTS="-Dpermissive-script-security.enabled=true"
```


idf_component_register(
    SRCS "main.c" 
         "../components/screen"
    INCLUDE_DIRS "."
)

set(COMPONENT_REQUIRES bus)                   
                    
                    
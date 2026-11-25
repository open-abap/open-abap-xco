INTERFACE if_xco_transport_layer PUBLIC.

  DATA value TYPE string READ-ONLY.

  METHODS get_transport_target
    RETURNING
      VALUE(ro_transport_target) TYPE REF TO if_xco_transport_layer.

ENDINTERFACE.

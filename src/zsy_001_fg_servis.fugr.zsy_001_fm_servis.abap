FUNCTION zsy_001_fm_servis.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_MATNR) TYPE  MATNR
*"  EXPORTING
*"     VALUE(ES_MALZEME) TYPE  ZSY_001_S_MALZEME
*"     VALUE(ET_STOK) TYPE  ZSY_001_TT_STOK
*"     VALUE(ES_RESULT) TYPE  ZSY_001_S_RESULT
*"----------------------------------------------------------------------

  SELECT
    mara~matnr,
    makt~maktx,
    mara~mtart,
    mara~meins
    FROM mara
    INNER JOIN makt ON makt~matnr = mara~matnr
                    AND makt~spras = @sy-langu
    WHERE mara~matnr = @iv_matnr
    INTO TABLE @DATA(lt_mara).

  SELECT
    werks,
    lgort,
    labst FROM mard
    WHERE matnr = @iv_matnr
    AND labst > 0
        INTO TABLE @DATA(lt_mard).


  IF iv_matnr IS NOT INITIAL.

    IF lt_mara IS NOT INITIAL.
      READ TABLE lt_mara INTO es_malzeme INDEX 1.
      IF sy-subrc EQ 0.
        es_result-resultcode = '0'.
        es_result-resulttype = 'OK'.
        es_result-resultdescription = 'SUCCESS'.
      ELSE .
        es_result-resultcode = '1'.
        es_result-resulttype = 'ERROR'.
        es_result-resultdescription = |{ iv_matnr } malzemesine ait bilgi bulunamadı.|.
      ENDIF.
    ENDIF.

    IF lt_mard IS NOT INITIAL.
      et_stok = lt_mard.
      IF sy-subrc EQ 0.
        es_result-resultcode = '0'.
        es_result-resulttype = 'OK'.
        es_result-resultdescription = 'SUCCESS'.
      ELSE .
        es_result-resultcode = '1'.
        es_result-resulttype = 'ERROR'.
        es_result-resultdescription = |{ iv_matnr } malzemesine ait bilgi bulunamadı.|.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFUNCTION.

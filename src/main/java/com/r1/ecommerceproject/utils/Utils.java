package com.r1.ecommerceproject.utils;

import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class Utils {
    /**
     * Restituisce l'URL completo della request (scheme://host[:port]/context/uri)
     * con eventuale query string esistente più un parametro aggiuntivo.
     *
     * @param request    la HttpServletRequest corrente
     * @param paramName  nome del parametro da aggiungere
     * @param paramValue valore del parametro da aggiungere
     * @return URL completo con il nuovo parametro correttamente encodato
     */
    public static String addRequestParameter(HttpServletRequest request,
                                             String paramName,
                                             String paramValue) {

        StringBuilder url = new StringBuilder();

        // 2. Query string esistente (senza '?')
        String qs = request.getQueryString();

        // 3. Encoding del nuovo valore
        String encodedValue = URLEncoder.encode(paramValue, StandardCharsets.UTF_8);

        // 4. Aggiungo '?' o '&' a seconda dei casi
        if (qs == null || qs.isEmpty()) {
            url.append('?')
                    .append(paramName).append('=').append(encodedValue);
        } else {
            url.append("?").append(replacePageParam(qs, encodedValue));
        }

        return url.toString();
    }

    public static String replacePageParam(String url, String newValue) {
        String key = "page=";
        int idx = url.indexOf(key);
        if (idx == -1) {
            // non c'è "page=": restituisco la stringa originale
            return url + "&page=" + newValue;
        }
        // calcolo inizio del valore corrente
        int start = idx + key.length();
        // trovo eventuale delimitatore successivo (&), altrimenti uso la fine
        int end = url.indexOf("&", start);
        if (end == -1) {
            end = url.length();
        }
        // ricostruisco la stringa con il nuovo valore
        return url.substring(0, start)
                + newValue
                + url.substring(end);
    }

    /**
     * 
     * @param selected array di stringhe in input
     * @param value valure da controllare
     * @return true se il valore è presente altrimenti falso
     */

    public static boolean isChecked(String[] selected, String value) {
        if (selected == null) return false;
        return Arrays.asList(selected).contains(value);
    }

    /**
     * Sfugge i caratteri speciali in una stringa JSON sostituendo le virgolette doppie con virgolette escaped
     * e rimuovendo i caratteri di nuova riga e ritorno carrello.
     *
     * @param s la stringa di input da fare l'escape, può essere null
     * @return la stringa JSON con l'escape, o una stringa vuota se l'input è null
     */
    public static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"").replace("\n", "").replace("\r", "");
    }
}
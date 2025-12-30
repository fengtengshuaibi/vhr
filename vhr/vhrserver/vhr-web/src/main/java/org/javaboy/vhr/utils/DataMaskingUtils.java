package org.javaboy.vhr.utils;

public class DataMaskingUtils {

    public static String maskName(String name) {
        if (name == null || name.isEmpty()) {
            return name;
        }
        if (name.length() <= 2) {
            return name.substring(0, 1) + "*";
        }
        return name.substring(0, 1) + "*" + name.substring(name.length() - 1);
    }

    public static String maskIdCard(String idCard) {
        if (idCard == null || idCard.isEmpty()) {
            return idCard;
        }
        if (idCard.length() < 10) {
            return idCard;
        }
        return idCard.substring(0, 6) + "**********" + idCard.substring(idCard.length() - 4);
    }

    public static String maskPhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return phone;
        }
        if (phone.length() < 7) {
            return phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }
    
    public static String maskAddress(String address) {
        if (address == null || address.isEmpty()) {
            return address;
        }
        if (address.length() <= 6) {
            return "******";
        }
        return address.substring(0, 3) + "******" + address.substring(address.length() - 3);
    }

    public static String maskAll(String value) {
        if (value == null) {
            return null;
        }
        return "******";
    }

    public static String mask(String value, String type) {
        if (value == null) {
            return null;
        }
        if ("NAME".equalsIgnoreCase(type)) {
            return maskName(value);
        } else if ("IDCARD".equalsIgnoreCase(type)) {
            return maskIdCard(value);
        } else if ("PHONE".equalsIgnoreCase(type)) {
            return maskPhone(value);
        } else if ("ADDRESS".equalsIgnoreCase(type)) {
            return maskAddress(value);
        } else {
            return maskAll(value);
        }
    }
}

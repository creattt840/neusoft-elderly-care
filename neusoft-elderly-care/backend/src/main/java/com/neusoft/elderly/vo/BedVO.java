package com.neusoft.elderly.vo;

/**
 * 床位 VO（含房间号，用于返回给前端）
 */
public class BedVO {
    private Long id;
    private Long roomId;
    private String bedNo;
    private Integer status;
    private Long elderlyId;
    private String roomNo;
    private Integer roomStatus;
    private String elderlyName;
    private Integer elderlyGender;
    private Integer elderlyAge;
    private String elderlyEmergencyContact;
    private String elderlyEmergencyPhone;
    private java.time.LocalDate checkInDate;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getRoomId() {
        return roomId;
    }

    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }

    public String getBedNo() {
        return bedNo;
    }

    public void setBedNo(String bedNo) {
        this.bedNo = bedNo;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Long getElderlyId() {
        return elderlyId;
    }

    public void setElderlyId(Long elderlyId) {
        this.elderlyId = elderlyId;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public Integer getRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(Integer roomStatus) {
        this.roomStatus = roomStatus;
    }

    public String getElderlyName() {
        return elderlyName;
    }

    public void setElderlyName(String elderlyName) {
        this.elderlyName = elderlyName;
    }

    public Integer getElderlyGender() {
        return elderlyGender;
    }

    public void setElderlyGender(Integer elderlyGender) {
        this.elderlyGender = elderlyGender;
    }

    public Integer getElderlyAge() {
        return elderlyAge;
    }

    public void setElderlyAge(Integer elderlyAge) {
        this.elderlyAge = elderlyAge;
    }

    public String getElderlyEmergencyContact() {
        return elderlyEmergencyContact;
    }

    public void setElderlyEmergencyContact(String elderlyEmergencyContact) {
        this.elderlyEmergencyContact = elderlyEmergencyContact;
    }

    public String getElderlyEmergencyPhone() {
        return elderlyEmergencyPhone;
    }

    public void setElderlyEmergencyPhone(String elderlyEmergencyPhone) {
        this.elderlyEmergencyPhone = elderlyEmergencyPhone;
    }

    public java.time.LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(java.time.LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }
}

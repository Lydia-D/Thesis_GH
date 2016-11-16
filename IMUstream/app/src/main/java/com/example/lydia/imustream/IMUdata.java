package com.example.lydia.imustream;

import android.hardware.SensorEvent;

/**
 * Created by Lydia on 17/11/2016.
 */

public class IMUdata {
    private float[] acc;
    private long time;
    public String id;

    public IMUdata(SensorEvent event){
        acc = event.values;
        time = event.timestamp;
        id = "Acc";
    }

    public void setAcc(float[] data){
        acc = data;
    }

    public String getAccDataStr(){
        String accStr = String.format(id+",%d,%3.5f,%3.5f,%3.5f\n",time,acc[0],acc[1],acc[2]);
        return accStr;
    }

    public String getAccDisp(){
        String display = String.format("X:%3.5f m/s^2  |  Y:%3.5f m/s^2  |   Z:%3.5f m/s^2", acc[0], acc[1],acc[2]);
        return display;
    }

}

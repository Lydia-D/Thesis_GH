package com.example.lydia.imustream;

import android.hardware.SensorEvent;
import android.util.Log;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Lydia on 17/11/2016.
 */

public class IMUdata {
    private float[] acc;
    private long time;
    public String id;
    private String DIFF;
    public float[] mean;
    public float[] stddev;
    static public IMUdata cal;



    public IMUdata(SensorEvent event){
        if (cal == null){
            acc = event.values;}
        else{
            acc[0] = event.values[0]-cal.acc[0];
            acc[1] = event.values[1]-cal.acc[1];
            acc[2] = event.values[2]-cal.acc[2];
        }
        time = event.timestamp;
        id = "Acc";
        DIFF = ",\t";
    }

    public float getx(){
        return acc[0];
    }

    public float gety(){
        return acc[1];
    }

    public float getz(){
        return acc[2];
    }

    public void setcalibrate(float[] mean,float[] stddev){
        cal.acc = mean;
        cal.stddev = stddev;
        cal.time = time;
        cal.id = "Cal_Acc";
        cal.DIFF =",\t";
    }

    public IMUdata getcalibrate(){
        return cal;
    }

    public String getAccDataStr(){
        String accStr = String.format(id+DIFF+"%d"+DIFF+"%3.5f"+DIFF+"%3.5f"+DIFF+"%3.5f\n",time,acc[0],acc[1],acc[2]);
        return accStr;
    }

    public String getAccDisp(){
        String display = String.format("X:%3.5f m/s^2  |  Y:%3.5f m/s^2  |   Z:%3.5f m/s^2", acc[0], acc[1],acc[2]);
        return display;
    }

    public static List<Float> extractvector(ArrayList<IMUdata> imulist, String strmethod){
        Iterator<IMUdata> IMUdataIterator = imulist.iterator();

            //Method method = imulist.getClass().getMethod(strmethod);
            List<Float> outputlist = new ArrayList<Float>(imulist.size());

            while (IMUdataIterator.hasNext()) {
                try {
                    Method method = IMUdataIterator.next().getClass().getMethod(strmethod);
                    float temp;
                    method.invoke(temp,null);
                    outputlist.add(temp);
                } catch (IllegalAccessException e) {
                    Log.e("ERROR in extractvector", e.toString());
                } catch (InvocationTargetException e) {
                    Log.e("ERROR in extractvector", e.toString());
                } catch (NoSuchMethodException e) {
                    Log.e("ERROR in extractvector", e.toString());
                }
            }
            return outputlist;

    }

}

package com.example.lydia.imustream;

import android.hardware.SensorEvent;
import android.util.Log;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

/**
 * Created by Lydia on 17/11/2016.
 */

public class IMUdata {
    private float[] acc;
    private long time;
    public String id;
    private String DIFF;
    public float[] stddev;
    static public IMUdata cal;

    public IMUdata(){
        acc = new float[3];
    }

    public IMUdata(SensorEvent event){
        if (cal == null){
            acc = event.values;
            cal = new IMUdata();
            //cal.acc = new float[3];
        }
        else{
            acc = new float[3];
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

    public static void setcalibrate(float[] mean,float[] stddev){
        cal.acc = mean;
        cal.stddev = stddev;
        //cal.time = time;     reference the time somehow?
        cal.id = "CAcc";
        cal.DIFF =",\t";
    }

    public static IMUdata getcalibrate(){
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
                    IMUdata object = IMUdataIterator.next();
                    Method method = object.getClass().getMethod(strmethod);
                    float temp = (float) method.invoke(object);
                    outputlist.add(temp);
                } catch (IllegalAccessException err) {
                    Log.e("ERROR in extractvector", err.toString());
                } catch (InvocationTargetException err) {
                    Log.e("ERROR in extractvector", err.toString());
                } catch (NoSuchMethodException err) {
                    Log.e("ERROR in extractvector", err.toString());
                }
            }
            return outputlist;

    }

}

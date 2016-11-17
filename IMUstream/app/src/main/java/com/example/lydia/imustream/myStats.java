package com.example.lydia.imustream;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Lydia on 17/11/2016.
 */

public class myStats {



    public static float getMean(List<Float> list){
        float sum = 0;
        for(float a: list)
            sum += a;
        return sum/list.size();
    }

    public static float getStdDev(List<Float> list, float mean) {
        float temp = 0;
        for(float a :list)
            temp += (a-mean)*(a-mean);
        return temp/list.size();
    }

    public static float getStdDev(List<Float> list) {
        float mean = getMean(list);
        float temp = 0;
        for(float a :list)
            temp += (a-mean)*(a-mean);
        return (float) Math.sqrt(temp/list.size());
    }




}

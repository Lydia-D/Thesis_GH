%% to align epoch

function all_RHO = calcdifference(avg_norm,X_ECEF_meas_vis,numSat,numRec)

    for k = 1:numSat
        all_RHO{k} = [];
    end
    
    for fromrec = 1:(numRec-1)
        for torec = fromrec+1:numRec
            for isat = 1:numSat
                % transform torec to time at fromrec
                % know location of sats
                trans_s = (X_ECEF_meas_vis(:,fromrec,isat)- X_ECEF_meas_vis(:,torec,isat));
                trans_p = -dot(avg_norm(:,isat),trans_s);
    %             trans_p = 0;
                diffp = range_com(torec,isat) - (range_com(fromrec,isat)+trans_p);
                all_RHO{isat} = [all_RHO{isat};diffp];
            end
        end
    end


end
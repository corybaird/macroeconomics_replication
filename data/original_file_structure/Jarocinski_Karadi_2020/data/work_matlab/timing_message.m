function msg = timing_message(it, nalldraws, timing_start)
timing_elapsed = now - timing_start;
timing_total = timing_elapsed*nalldraws/it;
timing_remain = timing_total - timing_elapsed;
timing_end = now + timing_remain;
msg_elapsed = ['elapsed ', datestr(timing_elapsed,13)];
msg_remain = ['remain ', datestr(timing_remain,13)];
% msg_elapsed = sprintf('elapsed %.1f', timing_elapsed*24);
% msg_remain = sprintf('remain %.1f', timing_remain*24);
msg_end = ['end ', datestr(timing_end,0)];
msg = [msg_elapsed, '; ', msg_remain, '; ', msg_end];
end

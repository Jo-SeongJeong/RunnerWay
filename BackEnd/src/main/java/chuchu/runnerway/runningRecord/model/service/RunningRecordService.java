package chuchu.runnerway.runningRecord.model.service;

import chuchu.runnerway.course.entity.Course;
import chuchu.runnerway.runningRecord.dto.request.RecordRegistRequestDto;
import chuchu.runnerway.runningRecord.dto.request.RecordUpdateCommentRequestDto;
import chuchu.runnerway.runningRecord.dto.request.RecordUpdatePictureRequestDto;
import chuchu.runnerway.runningRecord.dto.response.RecordDetailResponseDto;
import chuchu.runnerway.runningRecord.dto.response.RecordMonthData;
import chuchu.runnerway.runningRecord.dto.response.RecordResponseDto;
import chuchu.runnerway.runningRecord.entity.RunningRecord;

import java.util.List;
import java.util.Map;

public interface RunningRecordService {
    List<RecordResponseDto> getRecords(int year, int month, Integer day);

    RecordDetailResponseDto getRecord(Long recordId);

    RecordMonthData getAnalysisRecord(int year, int month);

    Map<String, Object> registRecord(RecordRegistRequestDto requestDto);

    void updateRecordPicture(RecordUpdatePictureRequestDto requestDto);

    void updateRecordComment(RecordUpdateCommentRequestDto requestDto);

}

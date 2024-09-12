package chuchu.runnerway.course.dto.response;

import chuchu.runnerway.course.dto.CourseImageDto;
import java.sql.Time;
import lombok.Data;

@Data
public class UserDetailResponseDto {
    private Long courseId;
    private String name;
    private String address;
    private String content;
    private Long count;
    private int level;
    private int averageSlope;
    private Time averageTime;
    private double courseLength;
    private double averageCalorie;
    private CourseImageDto courseImage;
}

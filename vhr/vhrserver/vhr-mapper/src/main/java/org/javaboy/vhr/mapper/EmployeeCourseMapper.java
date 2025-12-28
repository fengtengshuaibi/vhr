package org.javaboy.vhr.mapper;
import org.javaboy.vhr.model.EmployeeCourse;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface EmployeeCourseMapper {
    int deleteByPrimaryKey(Integer id);
    int insert(EmployeeCourse record);
    int insertSelective(EmployeeCourse record);
    EmployeeCourse selectByPrimaryKey(Integer id);
    int updateByPrimaryKeySelective(EmployeeCourse record);
    int updateByPrimaryKey(EmployeeCourse record);
    EmployeeCourse getEmployeeCourse(@Param("employeeId") String employeeId, @Param("courseId") Integer courseId);
    List<EmployeeCourse> getEmployeeCourses(@Param("employeeId") String employeeId, @Param("status") String status, @Param("type") String type);

    List<Map<String, Object>> getTrainingStats(@Param("keywords") String keywords);

    List<EmployeeCourse> getTop10ByScore();
    Double getTotalStudyHours(String employeeId);
    Integer getTotalExamScore(String employeeId);
    Integer getCompletedCourseCount(String employeeId);
}

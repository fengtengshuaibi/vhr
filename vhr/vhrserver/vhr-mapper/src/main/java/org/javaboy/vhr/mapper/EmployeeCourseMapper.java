package org.javaboy.vhr.mapper;
import org.javaboy.vhr.model.EmployeeCourse;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface EmployeeCourseMapper {
    int deleteByPrimaryKey(Integer id);
    int insert(EmployeeCourse record);
    int insertSelective(EmployeeCourse record);
    EmployeeCourse selectByPrimaryKey(Integer id);
    int updateByPrimaryKeySelective(EmployeeCourse record);
    int updateByPrimaryKey(EmployeeCourse record);
    EmployeeCourse getEmployeeCourse(@Param("employeeId") Integer employeeId, @Param("courseId") Integer courseId);
    List<EmployeeCourse> getEmployeeCourses(@Param("employeeId") Integer employeeId, @Param("type") String type);
    List<EmployeeCourse> getTrainingStats(@Param("keywords") String keywords);
    List<EmployeeCourse> getTop10ByScore();
    Double getTotalStudyHours(Integer employeeId);
    Integer getTotalExamScore(Integer employeeId);
    Integer getCompletedCourseCount(Integer employeeId);
}
